import
  happyx,
  ../openai/base,
  ../[common, colors],
  ./[button, input],
  ../native


type
  AuthorKind {. size: sizeof(int8), pure .} = enum
    User,
    GPT
  Message = object
    author*: AuthorKind
    text*: string


proc usrMsg*(text: string): Message =
  Message(text: text, author: User)


proc gptMsg*(text: string): Message =
  Message(text: text, author: GPT)



component Chat:

  messages: seq[Message] = @[
    usrMsg("Hello!"),
    gptMsg("Hello, user"),
    usrMsg("How r u?"),
    gptMsg("Im fine"),
  ]

  `template`:
    tDiv(class = "flex flex-col items-center w-full h-full"):
      nim:
        var message = ""
      # messages
      tDiv(class = "flex flex-col w-full h-full overflow-y-auto px-4 py-2 gap-2"):
        for message in self.messages:
          if message.author == User:
            tDiv(class = "px-2 py-1 rounded-md flex w-full bg-black/10 gap-2"):
              tSvg(viewBox="0 0 24 24", class = "w-6 h-6 fill-{primaryColor}{PrimaryColor} dark:fill-{primaryColor}{PrimaryColorDark}"):
                tPath(
                  d = "M6.02958 19.4012C5.97501 19.9508 6.3763 20.4405 6.92589 20.4951C7.47547 20.5497 7.96523 20.1484 8.01979 19.5988L6.02958 19.4012ZM15.9802 19.5988C16.0348 20.1484 16.5245 20.5497 17.0741 20.4951C17.6237 20.4405 18.025 19.9508 17.9704 19.4012L15.9802 19.5988ZM20 12C20 16.4183 16.4183 20 12 20V22C17.5228 22 22 17.5228 22 12H20ZM12 20C7.58172 20 4 16.4183 4 12H2C2 17.5228 6.47715 22 12 22V20ZM4 12C4 7.58172 7.58172 4 12 4V2C6.47715 2 2 6.47715 2 12H4ZM12 4C16.4183 4 20 7.58172 20 12H22C22 6.47715 17.5228 2 12 2V4ZM13 10C13 10.5523 12.5523 11 12 11V13C13.6569 13 15 11.6569 15 10H13ZM12 11C11.4477 11 11 10.5523 11 10H9C9 11.6569 10.3431 13 12 13V11ZM11 10C11 9.44772 11.4477 9 12 9V7C10.3431 7 9 8.34315 9 10H11ZM12 9C12.5523 9 13 9.44772 13 10H15C15 8.34315 13.6569 7 12 7V9ZM8.01979 19.5988C8.22038 17.5785 9.92646 16 12 16V14C8.88819 14 6.33072 16.3681 6.02958 19.4012L8.01979 19.5988ZM12 16C14.0735 16 15.7796 17.5785 15.9802 19.5988L17.9704 19.4012C17.6693 16.3681 15.1118 14 12 14V16Z"
                )
              tP:
                {message.text}
          else:
            tDiv(class = "px-2 py-1 rounded-md flex w-full bg-black/20 gap-2"):
              tImg(src = "favicon.png", class = "w-6 h-6 rounded-full")
              tP:
                {message.text}
      # input
      tDiv(class = "flex items-center w-full py-2 px-2 gap-2"):
        Input(
          "Edit text ...",
          proc(text: cstring) =
            message = $text,
          true
        ):
          tSvg(
            viewBox = "0 0 24 24",
            class = "select-none cursor-pointer hover:scale-110 active:scale-90 absolute right-4 w-8 duration-150 h-full stroke-{primaryColor}{PrimaryColor} dark:stroke-{primaryColor}{PrimaryColorDark}"
          ):
            tPath(
              d = "M10.3009 13.6949L20.102 3.89742M10.5795 14.1355L12.8019 18.5804C13.339 19.6545 13.6075 20.1916 13.9458 20.3356C14.2394 20.4606 14.575 20.4379 14.8492 20.2747C15.1651 20.0866 15.3591 19.5183 15.7472 18.3818L19.9463 6.08434C20.2845 5.09409 20.4535 4.59896 20.3378 4.27142C20.2371 3.98648 20.013 3.76234 19.7281 3.66167C19.4005 3.54595 18.9054 3.71502 17.9151 4.05315L5.61763 8.2523C4.48114 8.64037 3.91289 8.83441 3.72478 9.15032C3.56153 9.42447 3.53891 9.76007 3.66389 10.0536C3.80791 10.3919 4.34498 10.6605 5.41912 11.1975L9.86397 13.42C10.041 13.5085 10.1295 13.5527 10.2061 13.6118C10.2742 13.6643 10.3352 13.7253 10.3876 13.7933C10.4468 13.87 10.491 13.9585 10.5795 14.1355Z",
              "stroke-width" = "2",
              "stroke-linecap" = "round",
              "stroke-linejoin" = "round"
            )
