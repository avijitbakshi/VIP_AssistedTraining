function c=mc(cs,p)

if ~isstr(cs)
    if cs<=8
        cb=dec2bin(cs,3);
        c=[str2num(cb(1)) str2num(cb(2)) str2num(cb(3))];
        return
    end
end

if nargin==1
    switch cs
        case 'black'
            c=[0 0 0];
        case 'grey' 
         p=0.5;   c=[p p p];
        case 'lgrey' 
         p=0.8;  c=[p p p];
        case 'vlgrey' 
         p=0.95;  c=[p p p];
        case 'white'
            c=[1 1 1];
            
        case 'dgreen'
         p=100/255; c=[0 	p 	0];
        case 'green'
            c=[0 1 0];
        case 'lgreen'
        p=150/255;    c=[p 1 p];
         case 'vlgreen'
        p=210/255;    c=[p 1 p];
        
        
        case 'dred'
            p=100/255; c=[p 	0 	0];
        case 'ldred'
            p=220/255; c=[p 	0 	0];
        case 'red'
            c=[1 0 0];
        case 'lred'
            p=150/255; c=[1 p p];
        case 'magenta'
            c=[1 0 1];
        case 'orange'
         c=[255, 127, 0]/255;
        case 'yellow'
            c=[1 1 0];
            
        case 'blue'
            c=[0 0 1];
        case 'sky'
            c=[0 191 255]/255;
        case 'dblue'
            p=100/255; c=[0 0 p];
        case 'cyan'
            c=[0 1 1];
       case 'lblue'
            p=150/255; c=[p p 1];
            
        case 'pre'
            c=[1 0 0];
        case 'peri'
            c=[0 1 0];
        case 'perf'
            p=100/255; c=[0 	p 	0];%dark green
        case 'posti'
            p=150/255;    c=[p p 1];%light blue
        case 'postf'
            c=[0 0 1];
        case 'violet'
            p=1/255; c=[148, 0, 211]*p;
        case 'indigo'
            p=1/255; c=[75, 0, 130]*p;
        
%         case 1
%             c=[1 0 0];
%         case 2
%             c=[0 1 0];
%         case 3
%             c=[0 0 1];
        
            
        
    end
    
    
    
    
    
    
    
elseif nargin==2
    switch cs
        case 'grey'
         c=[p p p];
        case 'trial'
                    tr=p;
                    boundary=[1 4;5 24;25 34];
                    if p<=boundary(1,2)
                        c=cld(tr,[boundary(1,1) : boundary(1,2)],[1 0 0]);
                    elseif (boundary(2,2)-p)*(p-boundary(2,1))>=0
                        c=cld(tr,[boundary(2,1) : boundary(2,2)],[0 1 0]);
                    elseif p>=boundary(3,1)
                        c=cld(tr,[boundary(3,1) : boundary(3,2)],[0 0 1]);
                    end
    end
end


