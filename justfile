flatpak-manifest := "io.github.pyfa_org.Pyfa.json"

_default:
  @{{just_executable()}} --justfile {{justfile()}} --list

alias fedc := flatpak-external-data-checker
# run flatpak-external-data-checker against local manifest
flatpak-external-data-checker:
  flatpak run org.flathub.flatpak-external-data-checker --update --edit-only {{flatpak-manifest}}

alias build := flatpak-build
# build flatpak from local manifest
flatpak-build:
  flatpak run org.flatpak.Builder --force-clean --user --install-deps-from=flathub --repo=repo builddir {{flatpak-manifest}}

alias lint := flatpak-builder-lint
# run flathub linter on local manifest
flatpak-builder-lint:
  flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest {{flatpak-manifest}}

fpg-url := "https://raw.githubusercontent.com/flatpak/flatpak-builder-tools/dda10aa5949811589747e6e485da6ae2e86b5d2b/pip/flatpak-pip-generator.py"
alias fpg := flatpak-pip-generator
# generate a new python3-modules.json
flatpak-pip-generator:
  uv run --script {{fpg-url}} --runtime='org.gnome.Sdk//50' --cleanup=scripts --output=python3-modules \
  --prefer-wheels=logbook,numpy,matplotlib,contourpy,kiwisolver,pillow,greenlet,cryptography,cffi,pyyaml --wheel-arches x86_64 \
  wxPython logbook numpy matplotlib python-dateutil requests sqlalchemy\>=1.4,\<2.0 cryptography markdown2 roman beautifulsoup4 pyyaml python-jose requests-cache
