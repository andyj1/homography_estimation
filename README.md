#### Image Stitching (homography estimation)

- Image stitching from two planarly translated images using RANSAC in geometric transformation estimation
  - Homography Matrix
    ![CameraProjection](Input&#32;Images/camera_projection_ref_csail.png)
    - A homography matrix is needed to transform an image with 'x0' into another image 'x1'. This matrix solution comes down to a least squares problem, where, simply put, the eigenvector is to be found. 
    ![HomographyMatrix](Input&#32;Images/homography_matrix.png)
    which defines a least squares problem of ![Eq](Input&#32;Images/goal_eq.png)
        - since h vector is only defined up to scale, one only needs to find the unit vector h_{hat} (eigenvector of A_{transposed}*A with smallest eigenvalue)
        - works for 4+ points

  - RANSAC: Random Sample Consensus
    - Iterative estimation of parameters to a mathematical model from a set of observed data that contains outliers
    - Advantage: keeps match with the largest set of inliers (reducing the effect of large number of outliers when determining matched features), and taking average translation vector with only inliers
    - [Reference - RANSAC](http://portal.acm.org/citation.cfm?id=358692)
    - [Reference - Homography from MIT CSAIL](http://6.869.csail.mit.edu/fa12/lectures/lecture13ransac/lecture13ransac.pdf)
  - Applications of image stitching/homography estimation
    - video summarization and compression
    - panoramic, 360 deg image view for VR

- Demonstration
  - Images
  
    ![Inputs](Input&#32;Images/input.PNG)
  - Detected matching regions
  
    ![Output](Output&#32;Images/output.png)
  - Stitched together
  
    ![Stitched](Output&#32;Images/planarStitched.png)

- Next steps
  - Work with images that are taken with cameras in affine translation, perspective and rotational movement
