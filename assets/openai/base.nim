import
  happyx,
  strformat,
  asyncjs,
  jsffi,
  json


type
  OpenAIClient* = object
    token*: cstring
    base*: string
    modelName*: string
    chats*: JsonNode


proc newOpenAIClient*(token: string, base: string = "https://api.openai.com"): OpenAIClient =
  OpenAIClient(token: token, base: base, chats: newJArray())


var
  openAiClient* = newOpenAIClient("")
  currentChat* = remember -1


proc usrMsg*(text: string): JsonNode =
  %*{
    "content": text,
    "role": "user"
  }


proc gptMsg*(text: string): JsonNode =
  %*{
    "content": text,
    "role": "system"
  }


proc post*(self: OpenAIClient, url: cstring, body: cstring): Future[cstring] {.async.} =
  let authorization: cstring = fmt"Bearer {self.token}"
  var response: cstring
  {.emit: """//js
  let x = await fetch(`url`, {
    method: "POST",
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `authorization`
    },
    body: `body`
  });
  `response` = x.text();
  """.}
  return response


proc get*(self: OpenAIClient, url: cstring): Future[cstring] {.async.} =
  let authorization: cstring = fmt"Bearer {self.token}"
  var response: cstring
  {.emit: """//js
  let x = await fetch(`url`, {
    headers: {'Authorization': `authorization`}
  });
  `response` = x.text();
  """.}
  return response


proc createChatCompletion*(self: OpenAIClient, messages: JsonNode): Future[JsonNode] {.async.} =
  var response: cstring
  let
    url: cstring = fmt"{self.base}/v1/chat/completions"
    body: cstring = cstring $(%*{
      "model": self.modelName,
      "messages": messages
    })
  return parseJson($(await self.post(url, body)))


proc chatName*(self: OpenAIClient, messages: JsonNode): Future[string] {.async.} =
  var msgs = messages
  let
    url: cstring = fmt"{self.base}/v1/chat/completions"
    body: cstring = cstring $(%*{
      "model": self.modelName,
      "messages": [
        {
          "role": "user",
          "content": "Create a chat name based on the following data. " &
                     "In your message, write ONLY the chat name and NOTHING ELSE.\n" &
                     $msgs
        }
      ]
    })
  return (
    parseJson($(await self.post(url, body)))
  )["choices"][0]["message"]["content"].getStr
