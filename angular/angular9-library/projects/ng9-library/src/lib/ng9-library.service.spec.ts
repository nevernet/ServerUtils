import { TestBed } from '@angular/core/testing';

import { Ng9LibraryService } from './ng9-library.service';

describe('Ng9LibraryService', () => {
  let service: Ng9LibraryService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Ng9LibraryService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
