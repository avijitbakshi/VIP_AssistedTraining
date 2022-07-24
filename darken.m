function newcolor=darken(oldcolor, darkenbythis) %lower value of darkenbythis  0 - 255 darkens
if nargin<2
  newcolor=oldcolor.*170/255;
else
%  newcolor=oldcolor.*lightenbythis/255;  %THIS WAS LINE TILL JUNE 21 2018
 newcolor=oldcolor.*darkenbythis/255; % CHANGED IN JUNE 21 2018
end
