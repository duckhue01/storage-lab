package main

import (
	"context"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
)

var ctx = context.Background()

func main() {
	rdb := redis.NewClient(&redis.Options{
		Addr:     "127.0.0.1:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	_, err := rdb.SetNX(ctx, "name", "10 seconds values", 5*time.Second).Result()
	if err != nil {
		fmt.Println("redis error:", err)
	}

}
