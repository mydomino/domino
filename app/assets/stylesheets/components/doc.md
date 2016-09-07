# Buttons

## Default Buttons

All UI text should be written in sentence case.
All buttons are on a padding scale starting from `8px 16px` and increasing by `8px`. We use `rem` to style our buttons.

Small button = `8px 16px`
Medium button = `16px 24px`
Large button = `16px 48px`

Button should start with`.btn` and then modifiers are extended as different classes for size and color. ex: `.btn-primary` or `.btn-small`.

### Primary [.btn-primary]
This class applies background-color $blue and text-color $white.
.btn-primary {
  background-color: $blue;
  color: $white; }

### Secondary [.btn-secondary]
This class applies a border-color of $gray text-color of $gray. Also, there's a transparency applied, so that the background-color isn't white.
.btn-secondary {
border-color: $gray-80;
color: $gray-80;
-webkit-backface-visibility: hidden; }

### Small Button [.btn-sm]
