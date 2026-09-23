appid := "io.github.pyfa_org.Pyfa"
flatpak-manifest := "io.github.pyfa_org.Pyfa.json"
appstream-metainfo := "io.github.pyfa_org.Pyfa.metainfo.xml"

set default-list := true

# run flatpak-external-data-checker against local manifest
fedc:
  flatpak run org.flathub.flatpak-external-data-checker --update --edit-only {{flatpak-manifest}}

# build flatpak from local manifest
build:
  flatpak run org.flatpak.Builder --force-clean --user --install-deps-from=flathub --repo=repo builddir {{flatpak-manifest}}

# run flathub linter on local manifest
[group('lint')]
manifest-lint:
  flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest {{flatpak-manifest}}

# run flathub linter on local metainfo
[group('lint')]
appstream-lint:
  flatpak run --command=flatpak-builder-lint org.flatpak.Builder appstream {{appstream-metainfo}}

fpg-url := "https://raw.githubusercontent.com/flatpak/flatpak-builder-tools/dda10aa5949811589747e6e485da6ae2e86b5d2b/pip/flatpak-pip-generator.py"
# generate a new python3-modules.json
fpg:
  uv run --script {{fpg-url}} --runtime='org.gnome.Sdk//51' --cleanup=scripts --output=python3-modules \
  --prefer-wheels=logbook,numpy,matplotlib,contourpy,kiwisolver,pillow,greenlet,cryptography,cffi,pyyaml --wheel-arches x86_64 \
  --pyproject-file pyproject.toml
