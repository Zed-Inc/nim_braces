



proc testHelloWorld() {
  echo "Hello world"
  while i is not 5 {
    echo i
    i += 1
  }
  for i in 0..5{
    echo i
  }
}


#[
  nim output should be:
  with an indent size of 2
  
  proc testHelloWorld =
    echo "Hello World"
    
]#