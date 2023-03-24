package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"github.com/im15/openai-api-go"
	"os"
	"strings"
)

var (
	command string
	token   string
)

func init() {
	flag.StringVar(&command, "command", "chat", "[chat]")
	flag.StringVar(&token, "token", "", "OpenAI API key.")
	flag.Parse()

	if token == "" {
		token = os.Getenv("OPENAI_API_KEY")
	}
}

func main() {
	if token == "" {
		flag.PrintDefaults()
		return
	}

	var messages []*openai.ChatMessage

	for {
		reader := bufio.NewReader(os.Stdin)
		fmt.Print("User:\n> ")
		line, _, _ := reader.ReadLine()
		var prompt = string(line)
		if prompt == "quit" {
			return
		}
		messages = append(messages, &openai.ChatMessage{
			Role:    openai.RoleUser,
			Content: prompt,
		})

		fmt.Println()

		c := openai.NewClient(token)
		body, err := c.CreateChatCompletion(context.Background(), openai.ChatRequestBody{
			Model:    openai.GPT35Turbo,
			Stream:   true,
			Messages: messages,
		})
		if err != nil {
			fmt.Printf("create chat completion error: %v\n\n", err)
			continue
		}
		buf := strings.Builder{}
	b:
		for {
			select {
			case chunk, ok := <-body.StreamChan:
				if !ok {
					break b
				}
				if len(chunk.Choices) > 0 {
					choice := chunk.Choices[0]
					if choice.FinishReason != nil {
						fmt.Print("\n\n")
						break
					}
					if choice.Message != nil {
						fmt.Printf("chunk: %v", choice.Message)
					} else if choice.Delta != nil {
						if choice.Delta.Role != "" {
							fmt.Printf("%s:\n> ", strings.ToUpper(choice.Delta.Role))
						} else if choice.Delta.Content != "" {
							buf.WriteString(choice.Delta.Content)
							fmt.Print(choice.Delta.Content)
						}
					}
				}
			}
		}

		if buf.Len() > 0 {
			messages = append(messages, &openai.ChatMessage{
				Role:    openai.RoleAssistant,
				Content: buf.String(),
			})
		}
	}
}
