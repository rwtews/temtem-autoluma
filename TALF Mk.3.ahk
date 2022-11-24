-:: 
$stop := 0
$sleep := 500

monster1 := [[1260, 1340], 52]
monster2 := [[1660, 1740], 108]

CoordMode, pixel,screen
CoordMode, mouse,screen

test(arrX, y){
  MouseClick, , arrX[1], y
  Sleep 500
  MouseClick, , arrX[2], y
  Sleep 500
}

Walk(key) {
  Send { %key% down }
  Sleep 100
  Send { %key% up }
}

findMonster(arrX, y) {
  test(arrX, y)
  PixelSearch, Px, Py, arrX[1], y, arrX[2], y, 0xffffff, 1, Fast RGB
  if ErrorLevel {
    return false
  }
  return true
}

scanLuma(arrX, y, m) {
  Loop {
    test(arrX, y)
    PixelSearch, Px, Py, arrX[0], y, arrX[1], y, 0xffffff, 1, Fast RGB
    if !ErrorLevel {
      Sleep $sleep
      Loop {
        test(arrX, y)
        PixelSearch, Px, Py, arrX0, y, arrX[1], y, 0xfefefe, 1, Fast RGB
        if !ErrorLevel {
          MsgBox, % m
          $stop := 1
        }
        if ($stop) {
          return
        }
        else {
          Break
        }
      }
    }
  }
}

exitBattle() {
  Sleep 500
  MouseClick, Left, 970, 900, 1
  Sleep 500
  MouseClick, Left, 970, 900, 1
}

isBattle() {
  PixelSearch, Px, Py, 0, 0, 1920, 150, 0x3ce8ea, 0, Fast RGB
  if !ErrorLevel {
    return False
  }
  return true
}

Loop {
  if isBattle() {
    if findMonster(monster1[1], monster1[2]) {
      scanLuma(monster1[1], monster1[2], "Luma Found on top")
    } else if findMonster(monster2[1], monster2[2]) {
      scanLuma(monster2[1], monster2[2], "Luma Found on bottom")
    } else {
      exitBattle()
    }
  } else {
    Walk(a)
    Walk(d)
    Walk(w)
    Walk(s)
  }

  if ($stop) {
    return
  }
}

.:: $stop := 1