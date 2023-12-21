import unifetch


type
  OpenAIClient* = object
    token*: cstring



proc newOpenAIClient*(token: string): OpenAIClient =
  OpenAIClient(token: token)

