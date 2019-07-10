//
//  DeliveryDetailViewController.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit
import MapKit

class DeliveryDetailViewController: UIViewController {

    var viewModel: DetailViewEventHandler!
    private let identifier = "Annotation"
    private let height: CGFloat = 90
    private let imageWidth: CGFloat = 90
    private let regionRadius: CLLocationDistance = 500

    init(viewModel: DetailViewEventHandler) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Creating view

    lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        return view
    }()

    lazy var deliveryDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = AppConstant.borderWidth
        return view
    }()

    lazy var deliveryLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: AppConstant.fontSize)
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = AppConstant.numberOfLines
        lbl.textAlignment = .left
        return lbl
    }()

    lazy var deliveryImage: UIImageView = {
        let imgView = UIImageView(image: nil)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = AppLocalization.deliveryDetails
        self.setupUI()
        self.addConstraints()
        self.responseHandlerFromViewModal()
    }

    // MARK: Setting view

    /// for setup view to parent view
    func setupUI() {
        self.view.addSubview(mapView)
        mapView.addSubview(deliveryDetailView)
        deliveryDetailView.addSubview(deliveryImage)
        deliveryDetailView.addSubview(deliveryLabel)
    }

    /// For adding constraints
    func addConstraints() {
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                       right: view.rightAnchor, paddingTop: AppConstant.zero,
                       paddingLeft: AppConstant.zero, paddingBottom: AppConstant.zero,
                       paddingRight: AppConstant.zero, width: AppConstant.zero,
                       height: AppConstant.zero, enableInsets: false)

        if #available(iOS 11.0, *) {
            deliveryDetailView.anchor(top: nil, left: mapView.leftAnchor,
                                      bottom: mapView.safeAreaLayoutGuide.bottomAnchor,
                                      right: mapView.rightAnchor, paddingTop: AppConstant.zero,
                                      paddingLeft: AppConstant.commonPadding,
                                      paddingBottom: AppConstant.commonPadding,
                                      paddingRight: AppConstant.commonPadding, width: AppConstant.zero,
                                      height: AppConstant.zero, enableInsets: false)
        } else {
            deliveryDetailView.anchor(top: nil, left: mapView.leftAnchor,
                                      bottom: mapView.bottomAnchor, right: mapView.rightAnchor,
                                      paddingTop: AppConstant.zero, paddingLeft: AppConstant.commonPadding,
                                      paddingBottom: AppConstant.largePadding,
                                      paddingRight: AppConstant.commonPadding,
                                      width: AppConstant.zero, height: AppConstant.zero,
                                      enableInsets: false)
        }

        deliveryImage.anchor(top: deliveryDetailView.topAnchor, left: deliveryDetailView.leftAnchor,
                             bottom: nil, right: nil, paddingTop: AppConstant.commonPadding,
                             paddingLeft: AppConstant.commonPadding, paddingBottom: AppConstant.commonPadding,
                             paddingRight: AppConstant.zero, width: imageWidth, height: height,
                             enableInsets: false)

        deliveryLabel.anchor(top: deliveryDetailView.topAnchor, left: deliveryImage.rightAnchor,
                             bottom: deliveryDetailView.bottomAnchor,
                             right: deliveryDetailView.rightAnchor,
                             paddingTop: AppConstant.commonPadding,
                             paddingLeft: AppConstant.commonPadding,
                             paddingBottom: AppConstant.commonPadding,
                             paddingRight: AppConstant.commonPadding,
                             width: AppConstant.zero,
                             height: AppConstant.zero,
                             enableInsets: false)

        deliveryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(height)).isActive = true
    }

    // MARK: Data handler from view model

    /// handling responses from view model
    func responseHandlerFromViewModal() {
        viewModel.dataForDeliveryItem { [weak self] (address, url) in
            self?.deliveryLabel.text = address
            self?.deliveryImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"),
                                            options: nil, progressBlock: nil) { _ in
            }
        }

        viewModel.dataForMapView { [weak self] (address, latitude, longitude) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                let annotation = MKPointAnnotation()
                let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let viewRegion = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: self.regionRadius,
                                                    longitudinalMeters: self.regionRadius)
                annotation.coordinate = centerCoordinate
                annotation.title = address
                self.mapView.setRegion(viewRegion, animated: true)
                self.mapView.addAnnotation(annotation)
            }
        }

    }
}

// MARK: MKMapViewDelegate
extension DeliveryDetailViewController: MKMapViewDelegate {

    /// showing annotation
    ///
    /// - Parameters:
    ///   - mapView: mapview object
    ///   - annotation: annotation object
    /// - Returns: annotation view which has to be displayed on map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
