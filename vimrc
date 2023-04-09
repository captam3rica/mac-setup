{
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.formatOnType": true
  },
  "[shellscript]": {
    "editor.defaultFormatter": "foxundermoon.shell-format"
  },
  "atomKeymap.promptV3Features": true,
"autoDocstring.startOnNewLine": true,
  "css.format.spaceAroundSelectorSeparator": true,
  "editor.comments.ignoreEmptyLines": false,
  "editor.fontFamily": "Fira Code, monospace",
  "editor.formatOnPaste": true,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": true,
  "editor.minimap.maxColumn": 75,
  "editor.minimap.renderCharacters": false,
  "editor.minimap.showSlider": "always",
  "editor.minimap.side": "left",
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.renderLineHighlight": "all",
  "editor.rulers": [88],
  "editor.wordWrap": "wordWrapColumn",
  "editor.wordWrapColumn": 98,
  "flake8.args": [
    "--max-line-length",
    "88",
    "--ignore=E266,E501,W503"
  ],
"flake8.showNotifications": "always",
"python.defaultInterpreterPath": "/Users/captam3rica/.pyenv/shims/python",
  "python.analysis.diagnosticSeverityOverrides": {},
  "python.analysis.extraPaths": [],
"python.autoComplete.extraPaths": [],
  "python.formatting.provider": "black",
  "scm.diffDecorationsGutterPattern": {
    "modified": false
  },
  "scm.diffDecorationsGutterWidth": 4,
  "security.workspace.trust.untrustedFiles": "open",
  "workbench.activityBar.visible": false,
  "workbench.colorCustomizations": {
    "[Dracula Pro]": {
      "editor.findMatchBackground": "#E22E4E",
      "editor.findMatchBorder": "#ffff00",
      "editor.findMatchHighlightBorder": "#b38ee6",
      "editor.findMatchHighlightBackground": "#b38ee6",
      "editor.selectionHighlightBackground": "#980077",
      "editor.lineHighlightBackground": "#181818",
      "editor.lineHighlightBorder": "#181818",
      "editor.selectionBackground": "#980077",
      "editor.selectionHighlightBorder": "#000000",
      "editor.selectionForeground": "#E22E4E",
      "editor.wordHighlightStrongBackground": "#980077",
      "editor.wordHighlightBackground": "#980077",
      "editorGutter.deletedBackground": "#E22E4E",
      "editorGutter.modifiedBackground": "#96734c",
      "gitDecoration.deletedResourceForeground": "#E22E4E",
      "gitDecoration.modifiedResourceForeground": "#b38ee6",
      "gitDecoration.stageModifiedResourceForeground": "#b38ee6",
      "gitDecoration.untrackedResourceForeground": "#5be174",
      "minimap.selectionHighlight": "#980077",
      "minimapGutter.modifiedBackground": "#96734c",
      "panel.border": "#1A1921",
      "settings.modifiedItemIndicator": "#b38ee6",
      "sideBar.background": "#1A1921",
      "sideBar.foreground": "#656989",
      "sideBarSectionHeader.background": "#1A1921",
      "tab.activeBorder": "#1A1921",
      "tab.activeBorderTop": "#5be174",
      "tab.unfocusedActiveBorderTop": "#1A1921"
    }
  },
  "workbench.colorTheme": "Dracula Pro",
  "workbench.iconTheme": "atom-icons",
  "gitlens.advanced.messages": {
    "suppressLineUncommittedWarning": true
  },
  "explorer.confirmDelete": false,
  "editor.fontSize": 11,
  "editor.suggest.insertMode": "replace",
  "editor.wordBasedSuggestionsMode": "allDocuments",
  "shellcheck.ignorePatterns": {
    "**/*.zsh": false
  },
  "shellcheck.customArgs": [
    "--shell=bash",
    "--external-sources",
    "--severity=warning",
    "--exclude=SC2046,SC2053,SC2068,SC2179,SC2181,SC2199,SC2207,SC2229,SC2296"
],
"python.linting.flake8Path": "",
"python.linting.flake8Enabled": true,
"black-formatter.showNotifications": "always",
"settingsSync.ignoredSettings": [
    "-python.formatting.blackPath",
    "-flake8.showNotifications",
    "-python.linting.flake8Path"
],
  "workbench.preferredDarkColorTheme": "Dracula Pro",
  "workbench.preferredLightColorTheme": "Dracula Pro",
  "githubIssues.queries": [
    {},
    {
      "label": "My Issues",
      "query": "default"
    },
    {
      "label": "Created Issues",
      "query": "author:${user} state:open repo:${owner}/${repository} sort:created-desc"
    },
    {
      "label": "Recent Issues",
      "query": "state:open repo:${owner}/${repository} sort:updated-desc"
    }
  ],
  "editor.fontVariations": false,
  "python.formatting.blackPath": "",
"shellformat.path": "/opt/homebrew/bin/shfmt",
"isort.check": true,
"python.analysis.completeFunctionParens": true
}
