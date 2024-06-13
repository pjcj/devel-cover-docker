if [[ $autoenv_event == "enter" ]]; then
  _build() { reply=(`./BUILD options`) }
  compctl -K _build BUILD
else
fi
