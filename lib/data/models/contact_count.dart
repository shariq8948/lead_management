class ContactsCount {
  final String totalLead;
  final String totalTask;
  final String totalCall;
  final String totalPromotional;
  final String totalEmailCampaign;
  final String totalSMSCampaign;
  final String totalWhatsappCampaign;
  final String totalFollowup;
  final String totalMeeting;
  final String totalQuotation;

  ContactsCount({
    required this.totalLead,
    required this.totalTask,
    required this.totalCall,
    required this.totalPromotional,
    required this.totalEmailCampaign,
    required this.totalSMSCampaign,
    required this.totalWhatsappCampaign,
    required this.totalFollowup,
    required this.totalMeeting,
    required this.totalQuotation,
  });

  // Factory constructor to create an instance from JSON
  factory ContactsCount.fromJson(Map<String, dynamic> json) {
    return ContactsCount(
      totalLead: json['totalLead'] ?? '0',
      totalTask: json['totalTask'] ?? '0',
      totalCall: json['totalCall'] ?? '0',
      totalPromotional: json['totalPromotional'] ?? '0',
      totalEmailCampaign: json['totalEmailCampaign'] ?? '0',
      totalSMSCampaign: json['totalSMSCampaign'] ?? '0',
      totalWhatsappCampaign: json['totalWhatsappCampaign'] ?? '0',
      totalFollowup: json['totalFollowup'] ?? '0',
      totalMeeting: json['totalMetting'] ?? '0',
      totalQuotation: json['totalQuotation'] ?? '0',
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalLead': totalLead,
      'totalTask': totalTask,
      'totalCall': totalCall,
      'totalPromotional': totalPromotional,
      'totalEmailCampaign': totalEmailCampaign,
      'totalSMSCampaign': totalSMSCampaign,
      'totalWhatsappCampaign': totalWhatsappCampaign,
      'totalFollowup': totalFollowup,
      'totalMetting': totalMeeting,
      'totalQuotation': totalQuotation,
    };
  }
}
