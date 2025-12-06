//go:build 1

package main

import (
	"bytes"
	"fmt"
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
	matrix := bytes.Split(data, []byte{'\n'})

	isRoll := func(i int, j int) bool {
		return string(matrix[i][j]) == "@"
	}

	numRollNbrs := func(i int, j int) int {
		rows := len(matrix)
		cols := len(matrix[0])
		count := 0
		directions := [][2]int{
			{-1, -1}, {-1, 0}, {-1, 1},
			{0, -1}, {0, 1},
			{1, -1}, {1, 0}, {1, 1},
		}

		for _, dir := range directions {
			newI := dir[0] + i
			newJ := dir[1] + j

			if newI >= 0 && newI < rows && newJ >= 0 && newJ < cols {
				if isRoll(newI, newJ) {
					count += 1
				}
			}

		}

		return count

	}

	rollCount := 0

	for i := 0; i < len(matrix); i++ {

		for j := 0; j < len(matrix[0]); j++ {

			if isRoll(i, j) {

				c := numRollNbrs(i, j)
				if c < 4 {
					rollCount += 1
				}
			}
		}
	}

	fmt.Println(rollCount)
}
