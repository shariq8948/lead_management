// class SalesLead {
//   final String id;
//   final String customerName;
//   final SalesPipelineStage currentStage;
//   final int daysSinceLastActivity;
//   final DateTime lastActivityTimestamp;
//   final double potentialRevenue;
//   final LeadRiskCategory riskLevel;
//
//   const SalesLead({
//     required this.id,
//     required this.customerName,
//     required this.currentStage,
//     required this.daysSinceLastActivity,
//     required this.lastActivityTimestamp,
//     required this.potentialRevenue,
//     required this.riskLevel,
//   });
//
//   /// Calculates the risk level based on stage and stagnation duration
//   static LeadRiskCategory calculateRiskLevel(
//       SalesPipelineStage stage, int daysSinceLastActivity) {
//     switch (stage) {
//       case SalesPipelineStage.prospecting:
//         return daysSinceLastActivity > 30
//             ? LeadRiskCategory.high
//             : daysSinceLastActivity > 15
//                 ? LeadRiskCategory.moderate
//                 : LeadRiskCategory.low;
//       case SalesPipelineStage.qualification:
//         return daysSinceLastActivity > 25
//             ? LeadRiskCategory.high
//             : daysSinceLastActivity > 12
//                 ? LeadRiskCategory.moderate
//                 : LeadRiskCategory.low;
//       case SalesPipelineStage.proposal:
//         return daysSinceLastActivity > 20
//             ? LeadRiskCategory.high
//             : daysSinceLastActivity > 10
//                 ? LeadRiskCategory.moderate
//                 : LeadRiskCategory.low;
//       case SalesPipelineStage.negotiation:
//         return daysSinceLastActivity > 15
//             ? LeadRiskCategory.high
//             : daysSinceLastActivity > 7
//                 ? LeadRiskCategory.moderate
//                 : LeadRiskCategory.low;
//       default:
//         return LeadRiskCategory.low;
//     }
//   }
// }
// enum SalesPipelineStage {
//   prospecting,
//   qualification,
//   proposal,
//   negotiation,
//   closing,
//   won,
//   lost
// }
//
// /// Defines the risk level of a sales lead
// enum LeadRiskCategory { low, moderate, high }
