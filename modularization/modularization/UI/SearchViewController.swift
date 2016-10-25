import UIKit
import PureLayout
import YFoundation

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private var products: [Product] = [Product]()
    var category: CategoryTree
    
    // MARK: - View Elements
    let collectionView: UICollectionView
    
    // MARK: - Initializers
    init(
        category: CategoryTree
        )
    {
        self.category = category
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        apiRequest()
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        self.title = self.category.categoryName
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(SearchCollectionViewCell.self, forCellWithReuseIdentifier: String(SearchCollectionViewCell))
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    private func addConstraints() {
        collectionView.autoPinEdgeToSuperviewEdge(.Top)
        collectionView.autoPinEdgeToSuperviewEdge(.Left)
        collectionView.autoPinEdgeToSuperviewEdge(.Right)
        collectionView.autoPinEdgeToSuperviewEdge(.Bottom)
    }
    
    // MARK: - API
    private func apiRequest() {
        let url = Urls.search.rawValue + category.categoryId
        ApiClient.request(url, completion:{ data, res, error in
            self.products = Parser.searchListParse(data)
            self.collectionView.reloadData()
        })
    }
    
}


// MARK: - UITableViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(SearchCollectionViewCell), forIndexPath: indexPath ) as? SearchCollectionViewCell
        {
            cell.configureView(products[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.95, alpha: 1)

            return cell
        }
        return UICollectionViewCell()
    }
        
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.mainScreen().bounds.size
        let width = ( screenSize.width - (10 * 3) ) / 2
        let cellSize: CGSize = CGSizeMake( width, width * 1.2 )
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
