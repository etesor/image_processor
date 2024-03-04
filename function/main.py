#!/bin/python
from PIL import Image #Library to modify images
import os             #Library to interact with operating system     


def pil(path):
    with Image.open(path) as im:

            working_dir = os.getcwd()
            real_path = os.path.abspath(working_dir)
            real_path_plus_arch = os.path.join(real_path, "Pic-directory")

            try: 
                os.mkdir(real_path_plus_arch)#Generates a directory inside the project directory to store the generated images

            except FileExistsError: #File already exists, then, remove previous images
                previous_pic1 = os.path.join(real_path_plus_arch, 'square_image.jpg')
                previous_pic2 = os.path.join(real_path_plus_arch, 'vertical_image.jpg')
                previous_pic3 = os.path.join(real_path_plus_arch, 'lanscape_image.jpg')
                os.remove(previous_pic1)
                os.remove(previous_pic2)
                os.remove(previous_pic3)
            
            #Generate the new images
            #im.resize method input parameter is a tuple (width, height)
            sq_im = im.resize((1080, 1080))#Generates a square image 1:1 aspect ratio
            sq_im.save(os.path.join(real_path_plus_arch,'square_image.jpg'))


            vert_im = im.resize((1080, 1350))#Generates a vertical rectangle image 540:283 aspect ratio
            vert_im.save(os.path.join(real_path_plus_arch,'vertical_image.jpg'))
          

            landscape = im.resize((1080, 566))#Generates a landscape image 4:5 aspect ratio
            landscape.save(os.path.join(real_path_plus_arch,'lanscape_image.jpg'))

# Function to get the path of an image 
def main():
    image_name = "rocks.jpg"
    
    image_path = os.path.join('function', image_name)
    
    real_path = os.path.abspath(image_path)
    
    pil(real_path)
 
        
if __name__ == "__main__":
        main()