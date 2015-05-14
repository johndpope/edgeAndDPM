

I = imread('images/000084.jpg');
windowsCenters = [
     146         279;
         183         275;
         187         280;
         139         251;
         189         293;
         191         303;
         ];
xx = zeros(6,2);
xx(:,2) = windowsCenters(:,1);
xx(:,1) = windowsCenters(:,2);
minCircle(double(xx),I);
