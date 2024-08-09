import cv2
import numpy as np
import imageio
import os

def detect_and_match_features(img1, img2):
    orb = cv2.ORB_create()
    keypoints1, descriptors1 = orb.detectAndCompute(img1, None)
    keypoints2, descriptors2 = orb.detectAndCompute(img2, None)

    bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
    matches = bf.match(descriptors1, descriptors2)
    matches = sorted(matches, key=lambda x: x.distance)
    
    mapped_features_image = cv2.drawMatches(img1,keypoints1,img2,keypoints2,matches[:100],
                            None,flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)
    cv2.imshow("matches", mapped_features_image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    return keypoints1, keypoints2, matches



def estimate_homography(keypoints1, keypoints2, matches, threshold=3):
    src_points = np.float32([keypoints1[m.queryIdx].pt for m in matches]).reshape(-1, 1, 2)
    dst_points = np.float32([keypoints2[m.trainIdx].pt for m in matches]).reshape(-1, 1, 2)

    H, mask = cv2.findHomography(src_points, dst_points, cv2.RANSAC, threshold)
    return H, mask


def warp_images(img1, img2, H):
    h1, w1 = img1.shape[:2]
    h2, w2 = img2.shape[:2]

    point1 = np.float32([[0, 0], [0, h1], [w1, h1], [w1, 0]]).reshape(-1, 1, 2)
    point2 = np.float32([[0, 0], [0, h2], [w2, h2], [w2, 0]]).reshape(-1, 1, 2)
    warped_corners2 = cv2.perspectiveTransform(point2, H)

    corners = np.concatenate((point1, warped_corners2), axis=0)
    [xmin, ymin] = np.int32(corners.min(axis=0).ravel() - 0.5)
    [xmax, ymax] = np.int32(corners.max(axis=0).ravel() + 0.5)

    t = [-xmin, -ymin]
    Ht = np.array([[1, 0, t[0]], [0, 1, t[1]], [0, 0, 1]])

    warped_img2 = cv2.warpPerspective(img2, Ht @ H, (xmax - xmin, ymax - ymin))
    warped_img2[t[1]:h1 + t[1], t[0]:w1 + t[0]] = img1

    return warped_img2



def blend_images(img1, img2):
    # Resize img1 to match the shape of img2
    img1_resized = cv2.resize(img1, (img2.shape[1], img2.shape[0]))
    mask = np.where(img1_resized != 0, 1, 0).astype(np.float32)
    blended_img = img1_resized * mask + img2 * (1 - mask)
    return blended_img.astype(np.uint8)

def stitch(img1, img2):
    keypoints1, keypoints2, matches = detect_and_match_features(img1, img2)
    H, mask = estimate_homography(keypoints1, keypoints2, matches)
    warped_img = warp_images(img2, img1, H)
    output_img = blend_images(warped_img, img1)
    return warped_img

def resize_imag(image):
    # Get the original height and width
    height, width = image.shape[:2]

    # Calculate the new height and width
    new_height = int(height * 0.6)
    new_width = int(width * 0.6)

    # Resize the image
    resized_image = cv2.resize(image, (new_width, new_height))
    return resized_image

def calculateoutput(img1,img2):
        output1 = stitch(img1, img2)
        height, width, channels = output1.shape
        output1 = output1[10:height-10, 10:width-10]
        cv2.imshow('Stitched Image', output1)
        cv2.waitKey(0)
        cv2.destroyAllWindows()

        return output1

def stitchedimg(n,path):
     list_dir=os.listdir(path)
     if(n==2):
          img1 = cv2.imread(path+(list_dir[0]))
          img2 = cv2.imread(path+(list_dir[1]))
          output=calculateoutput(img1,img2)
     elif(n==3):
          img1 = cv2.imread(path+(list_dir[0]))
          img2 = cv2.imread(path+(list_dir[1]))
          img3=cv2.imread(path+list_dir[2])
          output1=calculateoutput(img1,img2)   
          output=calculateoutput(output1,img3)
     elif(n==4):
          img1 = cv2.imread(path+(list_dir[0]))
          img2 = cv2.imread(path+(list_dir[1]))
          img3 = cv2.imread(path+(list_dir[2]))
          img4 = cv2.imread(path+(list_dir[3])) 
          output1=calculateoutput(img1,img2)   
          output2=calculateoutput(img3,img4)
          output=calculateoutput(output1,output2)
     elif(n==5):
        img1 = cv2.imread(path+(list_dir[0]))
        img2 = cv2.imread(path+(list_dir[1]))
        img3 = cv2.imread(path+(list_dir[2]))
        img4 = cv2.imread(path+(list_dir[3])) 
        img5 = cv2.imread(path+(list_dir[4]))
        output1=calculateoutput(img1,img2)   
        output2=calculateoutput(output1,img3)
        output3=calculateoutput(img4,img5)
        output=calculateoutput(output2,output3)
            
     elif(n==6): 
        img1 = cv2.imread(path+(list_dir[0]))
        img2 = cv2.imread(path+(list_dir[1]))
        img3 = cv2.imread(path+(list_dir[2]))
        img4 = cv2.imread(path+(list_dir[3])) 
        img5 = cv2.imread(path+(list_dir[4]))
        img6 = cv2.imread(path+(list_dir[5])) 
        output1=calculateoutput(img1,img2)   
        output2=calculateoutput(output1,img3)
        output3=calculateoutput(img4,img5)
        output4=calculateoutput(output3,img6)
        output=calculateoutput(output2,output4) 

   
          
     return output
          


if __name__=="__main__":
    #  path=input("Enter path of image directory\n")
    #  n=int(input("Enter number of images\n"))
     path='page\\'
     n=4
     result=stitchedimg(n,path)
     result=cv2.cvtColor(result,cv2.COLOR_BGR2RGB)
     imageio.imwrite("result\\output"+'.png', result)


     
