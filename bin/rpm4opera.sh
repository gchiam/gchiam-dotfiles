#!/usr/bin/env bash

available () {
  command -v "$1" >/dev/null 2>&1
}

rpmcheck () {
  if [ -e "$1" ]; then
    echo "$1 is already present, delete it if you want to recreate it"
    exit 0
  fi
}

# Checked the required tools are installed
if ! available rpmbuild; then
  echo "You must install rpm-build to use this script" >&2
  exit 1
fi

if ! available ar; then
  echo "You must install GNU binutils to use this script" >&2
  exit 1
fi

# Check if automatic download has been selected
if [ "$1" = "-d" -o "$1" = "--developer" ]; then
  name=opera-developer
  appname=$name
  shift 1
elif [ "$1" = "-b" -o "$1" = "--beta" ]; then
  name=opera-beta
  appname=$name
  shift 1
elif [ "$1" = "-s" -o "$1" = "--stable" ]; then
  name=opera-stable
  appname=opera
  shift 1
fi
 
if [ -n "$name" ]; then

  # Make sure we have wget or curl
  if available wget; then
    silentdl="wget -qO-"
    louddl="wget"
    dloutput="-O"
  elif available curl; then
    silentdl="curl -s"
    louddl="curl"
    dloutput="-o"
  else
    echo "Install wget or curl" >&2
    exit 1
  fi
 
  # Work out the latest Opera version for selected stream
  version=$($silentdl http://deb.opera.com/opera/dists/stable/non-free/binary-amd64/Packages.gz | gzip -d | grep -A1 -x "Package: $name" | sed -n "/Version/s/.* //p")
 
  # Error out if $version is unset, e.g. because previous command failed
  if [ -z "$version" ]; then
    echo "Could not work out the latest version of $name; exiting" >&2
    exit 1
  fi

  # Define some variables
  deb=${name}_${version}_amd64.deb
  srcdir=/tmp      # Stick the build in /tmp so it will be auto-deleted on reboot
  outdir=/var/tmp  # Stick the rpm in /var/tmp so that it is not auto-deleted
  
  # Check if an rpm is already built
  rpm=${name}-${version}-0.x86_64.rpm
  rpmcheck "$outdir/$rpm"
  
  # Fetch the build if it is not already present
  if [ -e "$srcdir/$deb" ]; then
    echo "Using $srcdir/$deb as a source"
  else
    $louddl http://deb.opera.com/opera/pool/non-free/o/$name/$deb $dloutput "$srcdir/$deb"
    if ! [ "$?" = 0 ]; then
      echo "Download failed!" >&2
      exit 1
    fi
  fi

else

  # Perform some sanity checks on specified deb package
  if [ -z "$1" ]; then
    echo "You must specify the path to a locally stored Opera .deb package." >&2
    echo "Example usage: $(basename $0) opera.deb" >&2
    exit 1
  fi

  if ! echo "$1" | grep -Eq "opera.*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+.*\.deb$"; then
    echo "$1 is not named like a recent Opera .deb package" >&2
    exit 1
  fi

  if [ ! -r "$1" ]; then
    echo "$1 is either not present or cannot be read" >&2
    exit 1
  fi

  # Work out stream from the package name
  case "$1" in
    *developer*) name=opera-developer; appname=$name ;;
         *beta*) name=opera-beta; appname=$name ;;
       *stable*) name=opera-stable; appname=opera ;;
              *) echo "Cannot work out which stream this version of Opera is from" >&2; exit 1 ;;
  esac
  
  # Work out version from the package name
  version=$(echo "$1" | sed -r 's/.*[_-](([0-9]+\.)+[0-9]+)[_-].*/\1/')
  
  # Error out if $version is unset
  if [ -z "$version" ]; then
    echo "Could not work out the latest version of $name; exiting" >&2
    exit 1
  fi
  
  # Define some variables
  deb=$(basename $1)
  srcdir=$(cd "$(dirname $1)"; pwd)
  outdir=$(pwd)
  
  # Check if an rpm is already built
  rpm=${name}-${version}-0.x86_64.rpm
  rpmcheck "$outdir/$rpm"

fi

if [ ! -w "$outdir" ]; then
  echo "You do not have write permission to your output directory ($outdir)." >&2
  exit 1
fi

set -e

# Now the repack actually begins

repackdir=$(mktemp -t -d opera_repack.XXXXXX)

mkdir -p "${repackdir}"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

ln -s "$outdir" "$repackdir/RPMS/x86_64"
ln -s "$srcdir/$deb" "$repackdir/SOURCES/."

cat <<EOF > "${repackdir}/SPECS/opera.spec"
%define appname $appname
%define debug_package %{nil}

Summary:    Fast and secure web browser
Name:       $name
Version:    $version
Release:    0
Group:      Applications/Internet
License:    Proprietary
URL:        http://www.opera.com/browser
Source0:    $deb
Vendor:     Opera Software ASA
Packager:   ruario

%description
Opera is a fast, secure and user-friendly web browser. It
includes web developer tools, news aggregation, and the ability
to compress data via Opera Turbo on congested networks.

%prep

%setup -T -c

%build

%install

# Not needed on Fedora but it is on some other distros
mkdir -p "%{buildroot}"

# Unpack the deb, correcting the lib directory and removing debian directories
ar p %{SOURCE0} data.tar.xz | tar -xJf- -C %{buildroot} \\
  --transform="s,/usr/lib/.*-linux-gnu,%{_libdir}," \\
  --exclude="./usr/share/lintian" \\
  --exclude="./usr/share/menu"

# Fix the location of the doc directory on OpenSUSE
%if 0%{?suse_version}
  mkdir -p "%{buildroot}/%{_defaultdocdir}"
  mv "%{buildroot}/usr/share/doc/%{name}" "%{buildroot}/%{_defaultdocdir}/%{name}" 2>/dev/null ||:
%endif

# Set the correct permissions on the sandbox
chmod 4755 %{buildroot}%{_libdir}/%{appname}/opera_sandbox

# Correct the symlink due to changed lib directory
ln -fs %{_libdir}/%{appname}/%{appname} %{buildroot}%{_bindir}/%{appname}

%post

# Setup icons
touch -c /usr/share/icons/hicolor
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -tq /usr/share/icons/hicolor 2>/dev/null ||:
fi

# Setup desktop file
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications 2>/dev/null ||:
fi

%postun

# Remove compatibility symlinks
if [ -e "%{_libdir}/%{appname}/lib/libudev.so.0" ]; then
  rm -f %{_libdir}/%{appname}/lib/libudev.so.0
fi

if [ -e "%{_libdir}/%{appname}/lib/libcrypto.so.1.0.0" ]; then
  rm -f %{_libdir}/%{appname}/lib/libcrypto.so.1.0.0
fi

# Remove directories left behind due to compatibility symlinks
if [ -d "%{_libdir}/%{appname}/lib" ]; then
 rmdir --ignore-fail-on-non-empty %{_libdir}/%{appname}/lib
fi

if [ -d "%{_libdir}/%{appname}" ]; then
  rmdir --ignore-fail-on-non-empty %{_libdir}/%{appname}
fi

%clean
rm -rf %{buildroot}

%files
%{_defaultdocdir}/%{name}
%{_bindir}/%{appname}
%{_libdir}/%{appname}
%{_datadir}/applications/*.desktop
%{_datadir}/icons/*
%{_datadir}/pixmaps/*
EOF

echo "Repacking started. This may take a few minutes..."

if ! rpmbuild -bb --define "_topdir ${repackdir}" "${repackdir}/SPECS/opera.spec" >"${repackdir}/rpm-build.log" 2>&1; then
  echo "Something went wrong with packaging." >&2
  echo "Incomplete repack left in ${repackdir}" >&2
  exit 1
fi

rm -fr "${repackdir}"

echo "Created: $outdir/$rpm"
