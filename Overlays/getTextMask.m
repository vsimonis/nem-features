% Read example image 
function mask = getTextMask( imIn, theText, posX, posY)
   
   
    
    %Get a figure handle and add display the white image to it. 
    % Make an image the same size and put text in it 
    
    imshow(imIn),hold on
    text(posX,posY,theText,'Color','w','FontWeight','Bold','FontSize',20);
    tim = getframe;
    mask = tim;
    
%     
%     
%     
%     
%     hf = figure('color','white','units','normalized','position',[.1 .1 .8 .8]); 
%     image(blankSheet); 
%     set(gca,'units','pixels','position',[5, 5, size(rgbImage,2)-1 ,size(rgbImage,1)-1],'visible','off')
% 
%     % Text at specified position 
%     text('units','pixels','position',[posX posY],'fontsize',15,'string',theText) 
% 
% 
%     % Capture the text image 
%     % Note that the size will have changed by about 1 pixel 
%     tim = getframe(gca); 
%     close(hf) 
%     % Extract the cdata
%     tim2 = uint8(tim.cdata);
% 
%     % Make a mask with the negative of the text 
%     mask = tim2==0; 
    
    axis off
end