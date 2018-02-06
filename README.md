# IACC
Image Alignment and Color Compositing

## Single-scale Alignment
Using the SSD or Normalized cross correlation to calculate the loss between target image and reference image. Find the minimum loss in a small range of shift.

## Multi-scale Alignment
Using same method to calculate loss as the single-scale Alignment. But calculate a downsampled image first. Stage can be changed in the program. I use 3 stage in the project. I assume the lower stage always get the most correct position. Hence, except the lowest stage, other stage only shift 2 pixels in 4 directions to find the minimum loss.
Here is the image before and after alignment (combined with edge detection):
![unaligned](/demo/unalign.jpg)
![aligned](/demo/aligned.jpg)
## Automatic Rotation Correct
Some images have some rotation at very beginning. I tried to use Hough Transformation to correct the rotation. Transform it into Hough space and get the rotation of most lines. rotate the image with the angle to correct it.
![hough transform](/demo/rotate.jpg)

## Crop
To archive auto crop, I tried to using variance of every row and column to find border. Because the edge has single color in most time. However, for some image especially with the rotations there always have the black-white lines which could cause large variance. An alternative way is delete outlier points and ignore them.

![crop](/demo/croped.jpg)

**update**
Instead of using var to measure the change in each column/row, I tried to use diff to detect how much change in lines. This method gives pretty sweet result.
![crop_diff](/demo/crop_diff.jpg)

## Contrast
I using the histogram to increase contrast. Re-distribute the value of every pixels to make them more uniform. This equalizer is implemented by myself instead of using a build-in function.
![eq](/demo/eq.jpg)

## Edge Detection
With the calculating of loss on color. The better idea is calculate them on a higher semantic levels. The first this comes out is edge. With the using of edge detection, the performance increased a lot. In this project, I use Laplace of Gaussian to find the edges in the three color images. Then calculate the loss on the edge map to get the alignment. 

## Scaling During Alignment
The three images may have different scale. Therefore an scaling alignment can be added. But the scaling is not that obvious. The improvement is not that apparent.

## Some Other tries
I also tried to use Harris to find corners on the image. But there are too few overlaps to do the alignment. However there still could have some possibility to do with higher semantic levels like corners.
Another one was using the distribution of reference image histogram to adjust other two. But the they have mostly same distribute. The improvement was not that outstanding.

