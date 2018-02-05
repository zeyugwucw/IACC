aB_crop = aB(200:end-200, 200:end-200);
aG_crop = aG(200:end-200, 200:end-200);
ref_crop = ref(200:end-200, 200:end-200);

aB_edge = edge(aB_crop,'canny', 0.3);
aG_edge = edge(aG_crop,'canny', 0.3);
ref_edge = edge(ref_crop,'canny', 0.3);

corner_aB = detectHarrisFeatures(aB_edge);
corner_aG = detectHarrisFeatures(aG_edge);
corner_ref = detectHarrisFeatures(ref_edge);

subplot(221),imshow(ref_edge);
hold on;
plot(corner_ref.selectStrongest(200));
subplot(222),imshow(aG_edge);
hold on;
plot(corner_aG.selectStrongest(200));
subplot(223),imshow(aB_edge);
hold on;
plot(corner_aB.selectStrongest(200));
