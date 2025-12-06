//go:build 2

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

	rollNbrs := func(i int, j int) [][2]int {
		rows := len(matrix)
		cols := len(matrix[0])
		directions := [][2]int{
			{-1, -1}, {-1, 0}, {-1, 1},
			{0, -1}, {0, 1},
			{1, -1}, {1, 0}, {1, 1},
		}

		var neighbors [][2]int

		for _, dir := range directions {
			newI := dir[0] + i
			newJ := dir[1] + j

			if newI >= 0 && newI < rows && newJ >= 0 && newJ < cols {
				if isRoll(newI, newJ) {
					neighbors = append(neighbors, [2]int{newI, newJ})
				}
			}

		}

		return neighbors

	}

	rollCount := 0
	prevRollCount := -1

	for rollCount != prevRollCount {
		prevRollCount = rollCount

		var markDelete [][2]int

		for i := 0; i < len(matrix); i++ {

			for j := 0; j < len(matrix[0]); j++ {

				if isRoll(i, j) {

					nbrs := rollNbrs(i, j)
					if len(nbrs) < 4 {
						markDelete = append(markDelete, [2]int{i, j})
					}
				}
			}
		}

		for _, ij := range markDelete {
			i, j := ij[0], ij[1]
			if isRoll(i, j) {
				rollCount += 1
				matrix[i][j] = byte('.')
			}
		}

	}

	fmt.Println(rollCount)
}
