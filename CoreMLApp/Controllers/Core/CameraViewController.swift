
import UIKit
import CoreML
import Vision

class CameraViewController: UIViewController, UINavigationControllerDelegate {
    private let imagePicker = UIImagePickerController()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        return imageView
        
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .label
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("start", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("album", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "CoreML Mobile Net"
        
        view.addSubview(imageView)
        
        view.addSubview(label)
        
        view.addSubview(startButton)
        view.addSubview(saveButton)
        view.addSubview(albumButton)
        
        
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbumButton), for: .touchUpInside)

    }
    
    @objc private func didTapStartButton(){
        print("start button tapped")
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton(){
        print("save button tapped")
        
        let image: UIImage! = imageView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(CameraViewController.image(_: didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            label.text = "image save failed"
        }
        
        
    }
    
    @objc private func didTapAlbumButton(){
        print("album button tapped")
        let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
            
            label.text = "Tap [Start] to save a picture"
        }
        else{
            label.text = "error"
        }
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer){
        if error != nil{
            print(error.code)
            label.text = "save failed"
        }
        else{
            label.text = "save succeeded"
        }
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 10, y: 100, width: view.width-20, height: view.height-600)
        label.frame = CGRect(x: 10, y: imageView.bottom + 100, width: 300, height: 50)
        startButton.frame = CGRect(x: 10, y: label.bottom + 50, width: 80, height: 50)
        saveButton.frame = CGRect(x: startButton.right + 50, y: label.bottom + 50, width: 80, height: 50)
        albumButton.frame = CGRect(x: saveButton.right + 50, y: label.bottom + 50, width: 80, height: 50)
    }
    

}

extension CameraViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userSelectedImage = info[.originalImage] as? UIImage{
            imageView.image = userSelectedImage
            
            detectImageObject(image: userSelectedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    /// 画像からオブジェクトを検出・結果を出力
    func detectImageObject(image: UIImage) {
        // VNCoreMLModel(for: xx.modle): xxは使用するCore MLモデルによって変わります
        guard let ciImage = CIImage(image: image), let model = try? VNCoreMLModel(for: MobileNetV2Int8LUT().model) else {
            return
        }
        // Core MLモデルを使用して画像を処理する画像解析リクエスト
        let request = VNCoreMLRequest(model: model) { (request, error) in
            // 解析結果を分類情報として保存
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }

            // 画像内の一番割合が大きいオブジェクトを出力する
            if let firstResult = results.first {
                let objectArray = firstResult.identifier.components(separatedBy: ",")
                if objectArray.count == 1 {
                    self.navigationItem.title = firstResult.identifier
                } else {
                    self.navigationItem.title = objectArray.first
                }
            }
        }

        // 画像解析をリクエスト
        let handler = VNImageRequestHandler(ciImage: ciImage)

        // リクエストを実行
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

}
