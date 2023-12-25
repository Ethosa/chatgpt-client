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


var
  gptModels* = @[
    "gpt-4-1106-preview",
    "gpt-4-vision-preview",
    "gpt-4",
    "gpt-4-32k",
    "gpt-4-0613",
    "gpt-4-32k-0613",
    "gpt-3.5-turbo-1106",
    "gpt-3.5-turbo",
    "gpt-3.5-turbo-16k",
    "gpt-3.5-turbo-instruct",
  ]
  dallEModels* = @[
    "dall-e-3",
    "dall-e-2",
  ]
  ttsModels* = @[
    "tts-1",
    "tts-1-hd",
  ]
  whisperModels* = @[
    "whisper-1",
  ]
  embeddingModels* = @[
    "text-embedding-ada-002",
  ]
  moderationModels* = @[
    "text-moderation-latest",
    "text-moderation-stable",
  ]


proc newOpenAIClient*(token: string, base: string = "https://api.openai.com/v1"): OpenAIClient =
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
  `response` = await x.text();
  """.}
  echo response
  return response


proc get*(self: OpenAIClient, url: cstring): Future[cstring] {.async.} =
  let authorization: cstring = fmt"Bearer {self.token}"
  var response: cstring
  {.emit: """//js
  let x = await fetch(`url`, {
    method: "GET",
    headers: {'Authorization': `authorization`}
  });
  `response` = await x.text();
  """.}
  return response


proc createChatCompletion*(self: OpenAIClient, messages: JsonNode): Future[JsonNode] {.async.} =
  var response: cstring
  let
    url: cstring = fmt"{self.base}/chat/completions"
    body: cstring = cstring $(%*{
      "model": self.modelName,
      "messages": messages
    })
  return parseJson($(await self.post(url, body)))


proc chatName*(self: OpenAIClient, messages: JsonNode): Future[string] {.async.} =
  var msgs = messages
  let
    url: cstring = fmt"{self.base}/chat/completions"
    body: cstring = cstring $(%*{
      "model": self.modelName,
      "messages": [
        {
          "role": "user",
          "content": "Create a chat name based on the following data. Use language based on following data. " &
                     "In your message, write ONLY the chat name and NOTHING ELSE.\n" &
                     $msgs
        }
      ]
    })
  return (
    parseJson($(await self.post(url, body)))
  )["choices"][0]["message"]["content"].getStr


proc modelsList*(self: OpenAIClient): Future[seq[string]] {.async.} =
  let
    url: cstring = fmt"{self.base}/models"
    response = parseJson($(await self.get(url)))
  var res: seq[string] = @[]
  for i in response["data"]:
    res.add(i.getStr())
  return res
