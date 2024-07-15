#!/usr/bin/env bash

echo "#!/usr/bin/env bash" > install_extensions.sh
echo "" >> install_extensions.sh
code --list-extensions | xargs -Iex_name echo "code --install-extension ex_name --force" >> install_extensions.sh
chmod +x install_extensions.sh

