colorscheme default

if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
  set background=dark
else
  set background=light
endif

map <X1Mouse> gT
map <X2Mouse> gt

