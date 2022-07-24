function quad=getquadrand(th,v)
quad=0;
if th>0&&v>0 quad=1;elseif th<0&&v>0 quad=2; elseif th<0&&v<0 quad=3;elseif th>0&&v<0 quad=4;end  