import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Ng9LibraryComponent } from './ng9-library.component';

describe('Ng9LibraryComponent', () => {
  let component: Ng9LibraryComponent;
  let fixture: ComponentFixture<Ng9LibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Ng9LibraryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Ng9LibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
