//
//  TableViewModel.m
//  DigUpProject
//
//  Created by hugues on 15/09/15.
//  Copyright © 2015 hugues. All rights reserved.
//

#import "TableViewModel.h"

@interface TableViewModel()

@end

@implementation TableViewModel

- (id) initWithModel:(MaterialModel *)materialModel {
    self = [super initWithModel:materialModel];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize {
    self.cellsModels = [[NSMutableArray alloc] init];
    self.buttonsControllers = [[NSMutableDictionary alloc] init];
    
    NSData * data = [self.material.Text dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple * tableParser = [TFHpple hppleWithHTMLData:data];
    NSString * firstXPath = @"//div[not(ancestor::div)]";
    NSArray<TFHppleElement *> * tableLines = [tableParser searchWithXPathQuery:firstXPath];
    
    if (tableLines.count == 0) {
        NSLog(@"Error: Table is empty");
    }
    self.numberOfLines = tableLines.count;
    self.numberOfColumns = tableLines[0].children.count;
    
    for (int i = 0; i < self.numberOfLines; i++) {
        [self parseLineFromHppleElement:tableLines[i] WithCellsPerLine:self.numberOfColumns];
    }
}

- (CellViewModel *) parseCellFromHppleElement: (TFHppleElement *) cell andRowsInfo:(NSDictionary *) rowInfo{
    CellViewModel * newCell = [[CellViewModel alloc] init];
    
    if (rowInfo[@"class"] == nil) {
        newCell.rowClass = @"default";
    }
    else {
        newCell.rowClass = rowInfo[@"class"];
    }
    
    NSDictionary * rowStyle = [self parsingFunction:rowInfo[@"style"]];
    [newCell.style addEntriesFromDictionary:rowStyle];
    NSDictionary * cellInfo = cell.attributes;
    
    newCell.cellClass = cellInfo[@"class"];
    NSDictionary * cellStyle = [self parsingFunction:cellInfo[@"style"]];
    [newCell.style addEntriesFromDictionary:cellStyle];
    
    newCell.contentEditable = [cellInfo[@"contenteditable"] isEqualToString:@"true"];
    
    NSArray<TFHppleElement *>  * cellMaterialBlock = cell.children;
    [self addMaterials:cellMaterialBlock ToCell:newCell];
    
    return newCell;
}

- (void) parseLineFromHppleElement: (TFHppleElement *) line WithCellsPerLine:(NSUInteger) cellsPerLine {
    NSDictionary * rowInfo = line.attributes;
    
    NSArray<TFHppleElement *> * cellsInfo = [line children];
    for (int i = 0; i < cellsPerLine; i++){
        CellViewModel * newCell = [self parseCellFromHppleElement:cellsInfo[i] andRowsInfo:rowInfo];
        [self.cellsModels addObject:newCell];
    }
}

- (void) addMaterials:(NSArray<TFHppleElement *> *) materialsBlock ToCell:(CellViewModel *) cell {
    //The size is always one in the model for now
    for (int i = 0; i < materialsBlock.count; i++) {
        NSArray<TFHppleElement *>  * materialsForCell = materialsBlock[i].children;
        for (int j = 0; j < materialsForCell.count; j++) {
            if (materialsForCell[j].isTextNode) {
                NSString * label = materialsForCell[j].text;
                [cell.cellMaterials addObject:label];
            }
            else{
                NSArray * materialAttributes = materialsForCell[j].attributes;
                MaterialModel * materialModel;
            }
        }
    }
}

#warning parsing functions, may have to be moved later
//Parsing using NSScanner
- (NSDictionary *) parsingFunction:(NSString *) string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    while (!scanner.isAtEnd) {
        NSString *key = nil;
        float value = 0;
        
        BOOL didScan = [scanner scanUpToString:@":" intoString:&key] &&
                       [scanner scanString:@":" intoString:NULL] &&
                       [scanner scanFloat: &value] &&
                       [scanner scanUpToString:@";" intoString:NULL] &&
                       [scanner scanString:@";" intoString:NULL];
       result[key] = [NSNumber numberWithFloat:value];
        
        if (!didScan) {
            NSLog(@"Error: parsing the html but wrong format");
        }
    }
    return result;
}

@end
