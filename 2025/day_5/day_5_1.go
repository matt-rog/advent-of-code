//go:build 1

package main

import (
	"bytes"
	"fmt"
	"strconv"

	// "sort"

	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	fileName := os.Args[1]
	data, err := os.ReadFile(fileName)
	check(err)

	freshCount := 0

	dataSplit := bytes.Split(data, []byte("\n\n"))
	rangeLines := bytes.Split(dataSplit[0], []byte{'\n'})
	itemLines := bytes.Split(dataSplit[1], []byte{'\n'})

	var ranges [][2]int

	for _, rangeLine := range rangeLines {
		ab := bytes.Split(rangeLine, []byte{'-'})
		a, err := strconv.Atoi(string(ab[0]))
		check(err)
		b, err := strconv.Atoi(string(ab[1]))
		check(err)

		ranges = append(ranges, [2]int{a, b})
	}

	for _, itemLine := range itemLines {
		item, err := strconv.Atoi(string(itemLine))
		check(err)

		for _, r := range ranges {
			if item >= r[0] && item <= r[1] {
				freshCount += 1
				break
			}
		}
	}
	fmt.Println(freshCount)
}
