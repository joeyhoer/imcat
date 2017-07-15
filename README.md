# imcat

`imcat` concatenate images.

## Installation

Download the [`imcat` script](https://raw.githubusercontent.com/joeyhoer/imcat/master/imcat.sh) and make it available in your `PATH`.

    curl -o /usr/local/bin/imcat -O https://raw.githubusercontent.com/joeyhoer/imcat/master/imcat.sh && \
    chmod +x /usr/local/bin/imcat

## Example

```bash
# Concatenate all "Pictures" modified in the past 10 minutes
imcat $(find ~/Pictures/ -type f -name '*.png' -mmin -10 -print)
```
