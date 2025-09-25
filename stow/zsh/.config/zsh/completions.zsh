# vim: set ft=zsh:
# Zsh Completions Configuration
# Custom completion functions and settings

# Gradle/Gradlew completion function
_gradlew_completion() {
    local gradle_file
    local -a gradle_tasks

    # Find gradlew or gradle
    echo "gradlew completion" > DEBUG
    pwd >> DEBUG
    if [[ -f "./gradlew" ]]; then
        gradle_file="./gradlew"
    elif command -v gradle >/dev/null; then
        gradle_file="gradle"
    else
        return 1
    fi

    # Cache tasks for performance
    local cache_file=".gradle_tasks_cache"
    local gradle_build_file="build.gradle"
    [[ -f "build.gradle.kts" ]] && gradle_build_file="build.gradle.kts"

    # Refresh cache if build file is newer or cache doesn't exist
    if [[ ! -f "$cache_file" ]] || [[ "$gradle_build_file" -nt "$cache_file" ]]; then
        $gradle_file tasks --quiet --all --console=plain | command grep "^[a-zA-Z]" | command awk '{print $1}' > "$cache_file" 2>/dev/null
    fi

    # Read tasks from cache
    if [[ -f "$cache_file" ]]; then
        gradle_tasks=(${(f)"$(< $cache_file)"})
        _describe 'gradle tasks' gradle_tasks
    fi
}

# Register completion for gradlew
compdef _gradlew_completion gradlew
compdef _gradlew_completion ./gradlew
