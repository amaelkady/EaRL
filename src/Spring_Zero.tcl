
proc Spring_Zero {SpringID Node_i Node_j} {

element zeroLength $SpringID  $Node_i $Node_j -mat 9 -dir 6;

equalDOF    $Node_i     $Node_j    1     2;

}