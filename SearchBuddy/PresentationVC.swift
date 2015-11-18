//
//  PresentationVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/23/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit
import MediaPlayer

class PresentationVC: UIViewController,UIScrollViewDelegate {
    
    
    // AVPlayer
    var item : AVPlayerItem!
    var player : AVPlayer!
    var avLayer : AVPlayerLayer!
    
    // UI
    var tableViewToReload:UITableView?
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var titulo: UILabel!
    var texto: UILabel!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var registrarBt: UIButton!
    @IBOutlet weak var entrarBt: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do{
            try playVideo()
        } catch AppError.InvalidResource(let name, let type){
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Erro generico")
        }
        
        config()
        configurePageControl()
        load()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginScreen"{
            if let nextController = segue.destinationViewController as? LoginVC{
                nextController.tableViewToReload = self.tableViewToReload!
            }
        }else if segue.identifier == "registerScreen"{
            if let nextController = segue.destinationViewController as? RegisterVC{
                nextController.tableViewToReload = self.tableViewToReload
            }
        }
    }
    
    private func playVideo() throws {
        
        guard let path = NSBundle.mainBundle().pathForResource("video", ofType: "mp4") else {
            throw AppError.InvalidResource("video","mp4")
        }
        
        let pathURL = NSURL.fileURLWithPath(path)
        
        // AVPlayerItem
        self.item = AVPlayerItem(URL: pathURL)
        // AVPlayer
        self.player = AVPlayer(playerItem: self.item)
        // AVPlayerLayer
        self.avLayer = AVPlayerLayer(player: self.player)
        
        // Configurações da Layer
        self.avLayer.frame = self.view.bounds
        self.avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.player.play()
        self.avLayer.opacity = 0.7
        self.player.volume = 0.0
        self.view.layer.addSublayer(self.avLayer)
        
        self.player.actionAtItemEnd = .None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        player.seekToTime(kCMTimeZero)
        player.play()
        
    }
    
    enum AppError : ErrorType {
        case InvalidResource(String,String)
    }
    
    func config() {
        
        self.view.layer.zPosition = 1
        bg.layer.zPosition = 1
        registrarBt.layer.zPosition = 10
        entrarBt.layer.zPosition = 10
        
    }
    
    // PageControl
    func configurePageControl() {
        
        self.pageControl = UIPageControl(frame: CGRectMake(0, 0, 100, 20))
        self.pageControl.center = CGPointMake(UIScreen.mainScreen().bounds.width * 0.65 , UIScreen.mainScreen().bounds.height * 0.9)
        
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.orangeColor()
        self.pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        
        self.bg.addSubview(self.pageControl)
    }
    
    // ScrollView
    
    func load() {
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 552)) //UIScreen.mainScreen().bounds)
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.layer.zPosition = 2
        self.bg.addSubview(self.scrollView)
        
        var tamanho = CGFloat()
        
        for var i = 1; i <= 3; i++ {
            
            if i == 1 {
                self.titulo = UILabel(frame: CGRectMake(self.view.frame.size.width * 0.35, self.view.frame.size.height * 0.71, 120, 20))
                self.titulo.textColor = UIColor.whiteColor()
                self.texto = UILabel(frame: CGRectMake(0, self.view.frame.size.height * 0.75, 400, 50))
                self.texto.textColor = UIColor.whiteColor()
                self.texto.numberOfLines = 2
                self.titulo.font = UIFont(name: "Avenir Next", size: 22)
                self.texto.font = UIFont(name: "Avenir Next", size: 14)
                self.titulo.text = "Bem-vindo"
                self.texto.text = "Seja bem-vindo ao AchôPet\n que ajuda a procurar seu bichinho."
                self.texto.textAlignment = .Center
                tamanho = tamanho + self.view.frame.width
                
            }else if i == 2 {
                self.titulo = UILabel(frame: CGRectMake(self.view.frame.size.width * 1.35, self.view.frame.size.height * 0.71, 120, 20))
                self.titulo.textColor = UIColor.whiteColor()
                self.texto = UILabel(frame: CGRectMake(self.view.frame.size.width * 1.0, self.view.frame.size.height * 0.75, 400, 50))
                self.texto.numberOfLines = 2;
                self.texto.textColor = UIColor.whiteColor()
                self.titulo.font = UIFont(name: "Avenir Next", size: 22)
                self.texto.font = UIFont(name: "Avenir Next", size: 14)
                self.titulo.text = "História"
                self.texto.text = "Há vários animais perdidos no cotiadiano\nporém nada é feito para encontrá-los."
                self.texto.textAlignment = .Center
                tamanho = tamanho + self.view.frame.width
                
            }else {
                self.titulo = UILabel(frame: CGRectMake(self.view.frame.size.width * 2.35, self.view.frame.size.height * 0.71, 120, 20))
                self.titulo.textColor = UIColor.whiteColor()
                self.texto = UILabel(frame: CGRectMake(self.view.frame.size.width * 2.0, self.view.frame.size.height * 0.75, 400, 50))
                self.texto.numberOfLines = 2;
                self.texto.textColor = UIColor.whiteColor()
                self.titulo.font = UIFont(name: "Avenir Next", size: 22)
                self.texto.font = UIFont(name: "Avenir Next", size: 14)
                self.titulo.text = "Navegação"
                self.texto.text = "Muito intuitivo e de fácil manuseio\nvenha se tornar mais um usuário."
                self.texto.textAlignment = .Center
                tamanho = tamanho + self.view.frame.width
            }
            self.scrollView.addSubview(self.titulo)
            self.scrollView.addSubview(self.texto)
        }
        self.scrollView.contentSize = CGSizeMake(tamanho, self.scrollView.frame.size.height)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pagina = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width/2)/self.scrollView.frame.width)+1
        
        self.pageControl.currentPage = Int(pagina)
    }
    
}
