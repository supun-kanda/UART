img = imread('cameraman.tif');
[x,y] = size(img);
bufferSize = x*y+5;
sObject = serial('COM3','BaudRate',921600,'TimeOut',10, 'Terminator',10,'InputBufferSize',bufferSize);

fopen(sObject);

for i=1:x
    fwrite(sObject,img(i,:),'uint8');
end
%fwrite(sObject,[1:40],'uint8');
recieved = fread(sObject);
fclose(sObject)

vector = recieved(6:end);
output=vec2mat(vector,x);
imshow(uint8(output))