proc testHelloWorld() {
  echo "Hello world"
  while i is not 5 {
    echo i
    i += 1
  }
  # comment
  for i in 0..10 {
    for t in 0..50 {
      echo t
    }
    echo i
  }
}

var t = true
if t {
  echo "t is true"
}
