if 0
	warp = [ones(1,4) ones(1,4)*2 ones(1,4) ones(1,4)*.5];
	warp = cumsum(warp);
end

if 0	
	d1 = rand(1,max(warp));
	d1(1,:) = filter([1 1 1 1],[1],d1(1,:)')';
%	d1(2,:) = filter([1 1 1 1],[1],d1(2,:)')';	
	d2 = d1(:,warp);
end 

if 0
	d1 = rand(1,18);
	d1(5:8) = d1(5:8) + 10*sin((0:3)/3*pi);
	d1(14:17) = d1(14:17) + 10*sin((0:3)/3*pi);
	d2 = d1(warp);
end

if 1
	[w1 l1] = size(d1);
	[w2 l2] = size(d2);

	delta=0.05;
	ycount = floor(1/delta);
	yarray = zeros(ycount+1,max(l1,l2));
	for i=0:ycount
		lambda = i*delta;
		y = TimeWarp(d1,d2,p1,p2,lambda);
		yarray(i+1,1:length(y)) = y;
	end
	clg;
	imagesc(yarray);
end
