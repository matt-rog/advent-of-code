//go:build 2

package main

import (
	"bytes"
	"fmt"
	"os"
	"sort"
	"strconv"
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

	dataSplit := bytes.Split(data, []byte("\n\n"))
	rangeLines := bytes.Split(dataSplit[0], []byte{'\n'})

	var ranges [][2]int

	for _, rangeLine := range rangeLines {
		ab := bytes.Split(rangeLine, []byte{'-'})
		a, err := strconv.Atoi(string(ab[0]))
		check(err)
		b, err := strconv.Atoi(string(ab[1]))
		check(err)

		ranges = append(ranges, [2]int{a, b})
	}

	sort.Slice(ranges, func(i, j int) bool {
		return ranges[i][0] < ranges[j][0]
	})

	freshCount := 0
	highestSeen := 0
	for _, r := range ranges {
		a, b := r[0], r[1]
		fmt.Println(a, " ", b)
		if a < highestSeen {
			a = highestSeen
		}

		if b < a {
			continue
		}
		fmt.Println(b - a + 1)
		freshCount += b - a + 1
		highestSeen = b + 1

	}

	fmt.Println(freshCount)
}
