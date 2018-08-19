Supporting code for
[*Lenses for the Mere Mortal: PureScript Edition*](https://leanpub.com/lenses).


![](misc/cover.jpg)

Note by Michiel:

I needed to install the following:

- node (via brew)
- bower (via brew)
- npm install -g purescript
- npm install -g pulp

In emacs I installed the package purescript-mode and added this to my config:

;; https://queertypes.com/posts/34-purescript-emacs.html
(add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)
(add-hook 'purescript-mode-hook 'flycheck-mode)

Then:

bower install
pulp build
pulp repl
