Remove LMStudio installation, simplify clblast to just dnf module:

1. Delete `files/scripts/install-lmstudio.sh`
2. Delete `files/scripts/setup-clblast-symlinks.sh`
3. Delete `recipes/ai/lmstudio.yml`
4. Rename `recipes/ai/lmstudio-amd.yml` → `recipes/ai/clblast.yml` with simplified content (just dnf module, no symlinks)