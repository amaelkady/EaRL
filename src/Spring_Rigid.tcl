
proc Spring_Rigid {SpringID Node_i Node_j} {

element zeroLength $SpringID  $Node_i $Node_j -mat 99 99 99 -dir 1 2 6 -doRayleigh 1;;


}