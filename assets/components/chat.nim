import
  happyx,
  ../openai/base,
  ../[common, colors],
  ./[button, input],
  ../native,
  std/enumerate,
  asyncjs,
  json


component Chat:

  `template`:
    tDiv(class = "flex flex-col items-center w-full h-full"):
      nim:
        var message = ""
      # messages
      tDiv(class = "flex flex-col w-full h-full overflow-y-auto px-4 py-2 gap-2 mt-12 md:mt-0"):
        for (idx, message) in enumerate(openAiClient.chats[currentChat]["messages"].getElems):
          if message["role"].getStr == "system":
            discard
          if message["role"].getStr == "user":
            tDiv(class = "px-2 py-1 rounded-md flex flex-col w-full bg-black/10 gap-2"):
              tDiv(class = "flex gap-2"):
                tSvg(
                  viewBox="0 0 24 24",
                  class = "w-6 h-6 fill-{primaryColor}{PrimaryColor} dark:fill-{primaryColor}{PrimaryColorDark}"
                ):
                  tPath(
                    d = "M6.02958 19.4012C5.97501 19.9508 6.3763 20.4405 6.92589 20.4951C7.47547 20.5497 7.96523 20.1484 8.01979 19.5988L6.02958 19.4012ZM15.9802 19.5988C16.0348 20.1484 16.5245 20.5497 17.0741 20.4951C17.6237 20.4405 18.025 19.9508 17.9704 19.4012L15.9802 19.5988ZM20 12C20 16.4183 16.4183 20 12 20V22C17.5228 22 22 17.5228 22 12H20ZM12 20C7.58172 20 4 16.4183 4 12H2C2 17.5228 6.47715 22 12 22V20ZM4 12C4 7.58172 7.58172 4 12 4V2C6.47715 2 2 6.47715 2 12H4ZM12 4C16.4183 4 20 7.58172 20 12H22C22 6.47715 17.5228 2 12 2V4ZM13 10C13 10.5523 12.5523 11 12 11V13C13.6569 13 15 11.6569 15 10H13ZM12 11C11.4477 11 11 10.5523 11 10H9C9 11.6569 10.3431 13 12 13V11ZM11 10C11 9.44772 11.4477 9 12 9V7C10.3431 7 9 8.34315 9 10H11ZM12 9C12.5523 9 13 9.44772 13 10H15C15 8.34315 13.6569 7 12 7V9ZM8.01979 19.5988C8.22038 17.5785 9.92646 16 12 16V14C8.88819 14 6.33072 16.3681 6.02958 19.4012L8.01979 19.5988ZM12 16C14.0735 16 15.7796 17.5785 15.9802 19.5988L17.9704 19.4012C17.6693 16.3681 15.1118 14 12 14V16Z"
                  )
                tP:
                  {message["content"].getStr}
              tDiv(class = "flex gap-2 px-1"):
                tSvg(
                  viewBox = "0 0 24 24",
                  class = "w-4 h-4 stroke-{primaryColor}{PrimaryColor} dark:stroke-{primaryColor}{PrimaryColorDark}"
                ):
                  tPath(
                    d = "M15.4998 5.49994L18.3282 8.32837M3 20.9997L3.04745 20.6675C3.21536 19.4922 3.29932 18.9045 3.49029 18.3558C3.65975 17.8689 3.89124 17.4059 4.17906 16.9783C4.50341 16.4963 4.92319 16.0765 5.76274 15.237L17.4107 3.58896C18.1918 2.80791 19.4581 2.80791 20.2392 3.58896C21.0202 4.37001 21.0202 5.63634 20.2392 6.41739L8.37744 18.2791C7.61579 19.0408 7.23497 19.4216 6.8012 19.7244C6.41618 19.9932 6.00093 20.2159 5.56398 20.3879C5.07171 20.5817 4.54375 20.6882 3.48793 20.9012L3 20.9997Z",
                    "stroke-width" = "2",
                    "stroke-linecap" = "round",
                    "stroke-linejoin" = "round"
                  )
          else:
            tDiv(class = "px-2 py-1 rounded-md flex w-full bg-black/20 gap-2"):
              tImg(src = "favicon.png", class = "w-6 h-6 rounded-full")
              tP:
                {message["content"].getStr}
      # input
      tDiv(class = "flex items-center w-full py-2 px-2 gap-2"):
        Input(
          translate"Edit text ...",
          proc(text: cstring) =
            message = $text,
          true,
          "messageText",
          true,
          proc() {.async.} =
            document.getElementById("messageText").InputElement.value = ""
            openAiClient.chats[currentChat]["messages"].add(usrMsg(message))
            message = ""
            let response = await openAiClient.createChatCompletion(openAiClient.chats[currentChat]["messages"])
            openAiClient.chats[currentChat]["messages"].add(response["choices"][0]["message"])
            hpxNative.callNim("saveChats", $openAiClient.chats)
        )
