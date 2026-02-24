# Pull Request Body

This PR resolves all shellcheck warnings in the `tmux-layout-dwindle` script,
improving its robustness and reliability.

The following warnings have been addressed:

- **SC1007:** Corrected incorrect variable assignments.
- **SC2046:** Quoted command substitutions to prevent word splitting.
- **SC2086:** Double-quoted variable expansions to prevent globbing and word
  splitting.

Closes #51
