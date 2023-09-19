import UIKit

var greeting = "Hello, playground"

 

func checkWinner(submittedMoves:[Int]) -> Bool {
    for moves in winningMoves {
        if moves.allSatisfy(submittedMoves.contains) {
            return true
        }
    }
    return false
}

print(checkWinner(submittedMoves: [1,5,6,8]))
