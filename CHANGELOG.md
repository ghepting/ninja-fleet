# Changelog

## 1.0.0 (2026-02-05)


### Features

* adds keyboard mapping (CAPSLOCK -&gt; CTRL) for workstations ([430fbbf](https://github.com/ghepting/ninja-fleet/commit/430fbbf66ebb4ad06806109304ef6eb3c0c277ad))
* adds keyboard mapping (CAPSLOCK -&gt; CTRL) for workstations ([#2](https://github.com/ghepting/ninja-fleet/issues/2)) ([430fbbf](https://github.com/ghepting/ninja-fleet/commit/430fbbf66ebb4ad06806109304ef6eb3c0c277ad))
* adds openclaw and removes claude CLI from AI tools ([#19](https://github.com/ghepting/ninja-fleet/issues/19)) ([74635e5](https://github.com/ghepting/ninja-fleet/commit/74635e5213a2cc51db3e80eb43c9980d93ba8d56))
* adds pnpm installation and adds missing tags to various tasks ([#17](https://github.com/ghepting/ninja-fleet/issues/17)) ([5791bec](https://github.com/ghepting/ninja-fleet/commit/5791becc4d77ce8c4713498369bbca6a31dd467f))
* adds watch CLI to core ([#21](https://github.com/ghepting/ninja-fleet/issues/21)) ([b34e936](https://github.com/ghepting/ninja-fleet/commit/b34e93638e42ab8fa87fb91fe1718da6d79ade3e))
* initial setup of ansible for ninja-fleet ([93fca5d](https://github.com/ghepting/ninja-fleet/commit/93fca5d21a39e2a1b7003878214982831970e6c7))
* standardize git signing & transition homelab to full templates ([#15](https://github.com/ghepting/ninja-fleet/issues/15)) ([72a345f](https://github.com/ghepting/ninja-fleet/commit/72a345f6a326e2e129fe540d056718bcdb41888c))


### Bug Fixes

* ensures release-please uses signed commits via github app ([#10](https://github.com/ghepting/ninja-fleet/issues/10)) ([1e445eb](https://github.com/ghepting/ninja-fleet/commit/1e445eb2b06ca8fc545821539355d5eb4db6bb7b))
* fix wireguard conf filepath, use project path prefix variable wh… ([#12](https://github.com/ghepting/ninja-fleet/issues/12)) ([f9348ea](https://github.com/ghepting/ninja-fleet/commit/f9348ea804df449d8c4b01b15522d69fcb276221))
* fixups for linux workstations and defaults to wireguard split tunnel ([#11](https://github.com/ghepting/ninja-fleet/issues/11)) ([62018d1](https://github.com/ghepting/ninja-fleet/commit/62018d105f36bf702f971600095f68dca9c1de5e))
* prevent trailing newline from causing indeterministic thrash on Caddyfile ([#22](https://github.com/ghepting/ninja-fleet/issues/22)) ([b7b56af](https://github.com/ghepting/ninja-fleet/commit/b7b56afb7cc6aacc7114151977d1119f0f439aac))
* remove flatpak version of steam (use pacman/apt/dnf, etc) ([#13](https://github.com/ghepting/ninja-fleet/issues/13)) ([0b15d92](https://github.com/ghepting/ninja-fleet/commit/0b15d927647b3e2bca3c3a326a3b33f7c30bc0a2))
* source npm and fix openclaw installation to avoid prompt/interactive tty ([#20](https://github.com/ghepting/ninja-fleet/issues/20)) ([ab64b0c](https://github.com/ghepting/ninja-fleet/commit/ab64b0cef2a36be5780faeafecef4670cd3fc21a))
* standardize ~/.config/ninja-fleet.conf for private config source dir ([#14](https://github.com/ghepting/ninja-fleet/issues/14)) ([de6c1e6](https://github.com/ghepting/ninja-fleet/commit/de6c1e64b5353218a5475ae32b1880f4e43caf62))
