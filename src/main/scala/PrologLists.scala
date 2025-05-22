object PrologLists :
  private def convert[A](l: List[A]): String = l match
    case (h: Int) :: t => s"cons(${numToPeano(h)}, ${convert(t)})"
    case h :: t        => s"cons($h, ${convert(t)})"
    case _             => "nil"

  private def convertToListAndPrint[A](args: A*): Unit = println(convert(args.toList))

  private def numToPeano(n: Int): String = n match
    case 0 => "zero"
    case n => s"s(${numToPeano(n - 1)})"

  private def peanoToNum(s: String): Int = s match
    case "zero" => 0
    case s"s(${n})" => 1 + peanoToNum(n)

  private def printPeano(s: String): Unit =
    println(s"Peano to num => ${peanoToNum(s)}")

  private def printNum(n: Int): Unit =
    println(s"Num ($n) to Peano => ${numToPeano(n)}")

  def main(args: Array[String]): Unit =
    convertToListAndPrint(1, 5, 2, 3, 6, 3, 2, 1)
    convertToListAndPrint(1, 3, 0, 2, 1)
    convertToListAndPrint(1, 3, 2)
    convertToListAndPrint("a", "b", "c")
    printPeano("s(s(s(s(s(s(zero))))))")
    printNum(5)
    println:
      (1:: 2 :: 3 :: 4 :: Nil).take(10)
