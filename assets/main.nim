import
  happyx,
  common,
  colors,
  native,
  components/[
    input, button, settings, checkbox, chat
  ],
  pages/[main],
  openai/[base]


appRoutes "app":
  "/":
    Main
