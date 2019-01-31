%% init GIFWriter
clear all;
addpath('../dataset/');
gif_writer = GIFWriter;
gif_writer.init('../results/lizhi.gif', true);
%% read image
I = imread('image.jpg');
gif_writer.addImage(I, 'ԭͼ', 2);
%% convert image to hsv space to get coarse mask
h_thresh = [0.03, 0.95];
hsv = rgb2hsv(I);
h = hsv(:, :, 1);
s = hsv(:, :, 2);
H_mask = zeros(size(h));
H_mask(h < h_thresh(1)) = 1;
H_mask(h > h_thresh(2)) = 1;
S_mask = zeros(size(s));
S_mask(s > 0.05) = 1;
BW = H_mask .* S_mask;

gif_writer.addImage(BW, '��ֵ��', 2);
%% dilate to fill the gaps
SE1 = strel('sphere',6);
Dilated = imdilate(BW, SE1);

gif_writer.addImage(Dilated, '��������϶', 2);
%% rode to remove areas not in lychees
SE2 = strel('sphere',5);
Remove_others = Dilated;
while (1)
    Remove_others = imerode(Remove_others, SE2);
    [L, n] = bwlabel(Remove_others);
    gif_writer.addImage(Remove_others, 'ȥ������֦����', 0.1);
    if (n == 1)
        break;
    end
end
gif_writer.addImage(Remove_others, 'ȥ������֦����', 1);

%% seprate lychees
Seperate = Remove_others;
while (1)
    Seperate = imerode(Seperate, SE2);
    [L, n] = bwlabel(Seperate);
    gif_writer.addImage(Seperate, '��ʴ�ָ�����֦', 0.1);
    if (n == 2)
        break;
    end
end
gif_writer.addImage(Seperate, '��ʴ�ָ�����֦', 2);
Lizhis{1} = zeros(size(L)); Lizhis{2} = zeros(size(L));
Lizhis{1}(L == 1) = 1;
Lizhis{2}(L == 2) = 1;


%% get mass center
SE3 = strel('sphere', 1);
Eroded = Lizhis;
for i = [1, 2]
    while (1)
        tmp = imerode(Eroded{i}, SE3);
        if (sum(tmp, [1, 2]) == 0)
            break;
        end
        Eroded{i} = tmp;
        gif_writer.addImage(Eroded{i}, [num2str(i) '����֦��ʴ��'], 0.1);
    end
    gif_writer.addImage(Eroded{i}, [num2str(i) '����֦��ʴ��'], 1);
end
gif_writer.addImage(Eroded{1} + Eroded{2}, '��ʴ���', 2);
%%
rc{2} = {};
for i = [1, 2]
    [r, c] = find(Eroded{i} == 1);
    rc{i} = [mean(r), mean(c)];
end
z = Eroded{1} + Eroded{2};
for i = 1 : 2
    z = insertShape(z, 'circle', [rc{i}(2), rc{i}(1) 5], 'LineWidth', 5);
end

gif_writer.addImage(z, 'ȷ����������', 2);

%% get result
result = I;
for i = 1 : 2
    result = insertShape(result, 'circle', [rc{i}(2), rc{i}(1) 5], 'LineWidth', 5);
end
gif_writer.addImage(result, '������ȡ���', 3);
gif_writer.write();

%% show the results
figure();
ax = zeros(1, 8);
ax(1) = subplot(241);
imshow(I);
title('ԭͼ');
linkaxes(gca);

ax(2) = subplot(242);
imshow(BW);
title("��ֵ��");
linkaxes(gca);

ax(3) = subplot(243);
imshow(Dilated);
title("��������϶");
linkaxes(ax);

ax(4) = subplot(244);
imshow(Remove_others);
title("��ʴȥ������֦����");
linkaxes(ax);

ax(5) = subplot(245);
imshow(Lizhis{1} + Lizhis{2});
title("��ʴ�ָ�����֦");
linkaxes(ax);

ax(6) = subplot(246);
imshow(Eroded{1} + Eroded{2});
title("��ʴ���");
linkaxes(ax);

ax(7) = subplot(247);
imshow(z);
title("ȷ����������");
linkaxes(ax);

ax(8) = subplot(248);
imshow(result);
title("������ȡ���");
linkaxes(ax);

%% write results to file
rcs = [rc{1};rc{2}];
rcs = [rcs(:, 2) rcs(:, 1)];
prefix = '../results/process/';
imwrite(BW, [prefix 'BW.jpg']);
imwrite(Dilated, [prefix 'dilate.jpg']);
imwrite(Remove_others,[prefix 'refine.jpg']);
imwrite(Seperate, [prefix 'seperate.jpg']);
imwrite(Eroded{1} + Eroded{2}, [prefix 'eroded.jpg']);
imwrite(z, [prefix 'coor.jpg']);
imwrite(result, '../results/result.jpg');
save('coordinate.txt', 'rcs', '-ASCII');