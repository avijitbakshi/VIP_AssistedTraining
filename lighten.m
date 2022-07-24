function newcolor=lighten(oldcolor, lightenbythis) %lighten 0 = old color no lightening ; 255 = total lighten
if nargin<2
  newcolor=([1 1 1]-oldcolor).*170/255 +oldcolor;
else
 newcolor=([1 1 1]-oldcolor).*lightenbythis/255 +oldcolor;   
end
