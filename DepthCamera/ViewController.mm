//
//  ViewController.m
//  DepthCamera
//
//  Created by Rob Makina on 4/26/22.
//

#import "ViewController.h"
#import "depthai/depthai.hpp"
#import <opencv2/opencv.hpp>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    using namespace std;
    // Create pipeline
    
    // Output queue will be used to get the rgb frames from the output defined above
    dispatch_async(dispatch_get_main_queue(), ^{
        dai::Pipeline pipeline;

        // Define source and output
        auto camRgb = pipeline.create<dai::node::ColorCamera>();
        auto xoutRgb = pipeline.create<dai::node::XLinkOut>();

        xoutRgb->setStreamName("rgb");

        // Properties
        camRgb->setPreviewSize(1024, 720);
        camRgb->setBoardSocket(dai::CameraBoardSocket::RGB);
        camRgb->setResolution(dai::ColorCameraProperties::SensorResolution::THE_4_K);
        camRgb->setInterleaved(false);
        camRgb->setColorOrder(dai::ColorCameraProperties::ColorOrder::RGB);

        // Linking
        camRgb->preview.link(xoutRgb->input);

        // Connect to device and start pipeline
        dai::Device device(pipeline, dai::UsbSpeed::SUPER);

        cout << "Connected cameras: ";
        for(const auto& cam : device.getConnectedCameras()) {
            cout << cam << " ";
        }
        cout << endl;

        // Print USB speed
        cout << "Usb speed: " << device.getUsbSpeed() << endl;

        auto qRgb = device.getOutputQueue("rgb", 4, false);

    // Do any additional setup after loading the view.
    
        while(true) {
            auto inRgb = qRgb->get<dai::ImgFrame>();

            // Retrieve 'bgr' (opencv format) frame
            cv::imshow("rgb", inRgb->getCvFrame());

            int key = cv::waitKey(1);
            //if(key == 'q' || key == 'Q') {
            //    break;
            //}
        }
    });
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
